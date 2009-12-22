Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbZLVPH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbZLVPH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZLVPHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:07:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:27908 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbZLVPHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:07:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oolKkmGKqGjc7A8gHnQ1sov4MtVv48teK6NF1nxG8AIWhErE/6yO4IAkE6xkGzPZHL
         h/kZnpy9Vg4MqdRAqmIvbYveoe+8PGraN/QVC6OTOiWypD2L0t+NOW+inePp1KaVM3R8
         ayBLwqKH1JfZTjeRUXg9Nvbs2SA0IhaDgQHn8=
Message-ID: <4B30E09E.7080200@gmail.com>
Date: Tue, 22 Dec 2009 16:07:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-13.1 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: linux-next: manual merge of the limits tree with the  tree
References: <20091219094616.744fc1c1.sfr@canb.auug.org.au>
In-Reply-To: <20091219094616.744fc1c1.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 11:46 PM, Stephen Rothwell wrote:
> Today's linux-next merge of the limits tree got a conflict in fs/exec.c
> between commit f6151dfea21496d43dbaba32cfcd9c9f404769bc ("mm: introduce
> coredump parameter structure") from the  tree and commit
> 1157605c47673fc63b052df4688697695a9873d5 ("FS: use helpers for rlimits")
> from the limits tree.
> 
> I fixed it up (see below - thanks Andrew) and can carry the fix for a
> while.

Thanks, I fixed that in my tree and pushed now.

-- 
js

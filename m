Return-Path: <linux-kernel-owner+w=401wt.eu-S1760423AbZDHFyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423AbZDHFyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZDHFyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:54:00 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:48820 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbZDHFx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pmB1/nDV30g3rqSGwP6xxhTeu9yUSEns1f2hS/jmXqbWJo2tKHJ3u9QAv5ZAUPQfbU
         r3mELvkXeScQHL0YXXVktt7ey0YQMvrV06jfdW/t1Aomi2VincFNNHpmPnFDcgsF78u3
         ze/KqkFz4AIxcqctnkHfhgNC9hQweRxSEdOgY=
MIME-Version: 1.0
In-Reply-To: <20090408054612.GA6744@ldl.fc.hp.com>
References: <20090408003921.GA5054@ldl.fc.hp.com>
	 <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com>
Date: Wed, 8 Apr 2009 08:53:57 +0300
X-Google-Sender-Auth: 733a2b4d168b8da1
Message-ID: <84144f020904072253j4c8b338we034f687da783280@mail.gmail.com>
Subject: Re: cross-compilers
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alex Chiang <achiang@hp.com>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Wed, Apr 8, 2009 at 8:46 AM, Alex Chiang <achiang@hp.com> wrote:
> I guess the question remains for Andrew. Since I pretty much did
> all the work needed to update his cross-compiler repo, is there
> still value in it?

I don't know about Andrew, but Vegard might be interested:

http://www.kernel.org/pub/tools/crosstool/

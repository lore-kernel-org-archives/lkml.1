Return-Path: <linux-kernel-owner+w=401wt.eu-S933607AbZJIPdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbZJIPdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933396AbZJIPdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:33:10 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:46458 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383AbZJIPdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=IeeIhtVd5DKgohTbv3NOxfY0zR7mi8ypRRDM4zBgcNNyzoSv/VNUBNNPJtUoiDiGGx
         TDpJbh7n2ewPrC7VlxUV/imw7N6llc1ZkKBvVacoX8PwZABrLL5dHPTJKKLuUh4AAwYT
         AeuDMdzXDzdBZSbdvEJEEknwIVCT2tE2+jMII=
Message-ID: <4ACF578D.7080505@gmail.com>
Date: Fri, 09 Oct 2009 17:32:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.7 Thunderbird/3.0b4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: akpm <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org
Subject: Re: kvm build failure [was: mmotm 2009-10-09-01-07 uploaded]
References: <200910090830.n998Ubvv020464@imap1.linux-foundation.org>	<4ACF09D7.9030901@gmail.com> <20091009083028.61f44133.rdunlap@xenotime.net>
In-Reply-To: <20091009083028.61f44133.rdunlap@xenotime.net>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2009 05:30 PM, Randy Dunlap wrote:
> I submitted a patch for that several days ago, against
> linux-next-20091006.  (below again)

Thanks!

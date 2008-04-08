Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbYDHFJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbYDHFJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 01:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYDHFIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 01:08:52 -0400
Received: from indigo.cs.bgu.ac.il ([132.72.42.23]:57398 "EHLO
	indigo.cs.bgu.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYDHFIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 01:08:51 -0400
Date: Tue, 8 Apr 2008 08:10:07 +0300 (IDT)
Message-Id: <200804080510.m385A7DF016568@indigo.cs.bgu.ac.il>
From: "eial@cs.bgu.ac.il" <eial@cs.bgu.ac.il>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: keyboard disconnects with kernel 2.6.24-r4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Organization: CS Department
X-Mailer: CS Webmail v3.10
In-Reply-To: <Pine.LNX.4.64.0804072357280.26562@twin.jikos.cz>
X-Priority: 3 (Normal)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

r3 and r4 are rc3 and rc4, currently, the stable version is rc4, I try to stay with the current stable version inorder to reduce bugs
cause I'm studying and dont have much free time on hand, can I disable this issue in rc4?
On Tue 08 Apr 0:58 2008 Jiri Kosina wrote:
> On Mon, 7 Apr 2008, eial@cs.bgu.ac.il wrote:
> 
> > hello, I own a DV9000z, running gentoo and kernel 2.6.24-r3 on it, I'm 
> > not using r4 because while working with the computer, after a while, my 
> > keyboard disconnects. trying to shutdown the computer causes in system 
> > freeze. this do not happens in r3, 
> 
> What are "r3" and "r4"? Do you mean -rc3 and -rc4? If so, please try to 
> reproduce with recent kernel first (we are now past 2.6.25-rc8), and 
> report back in case the problem still persists.
> 
> -- 
> Jiri Kosina
> SUSE Labs
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 





Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbXJ3QGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbXJ3QGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbXJ3QGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:06:34 -0400
Received: from rzcomm22.rz.tu-bs.de ([134.169.9.68]:40267 "EHLO
	rzcomm22.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbXJ3QGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:06:34 -0400
Message-ID: <47275680.9080703@l4x.org>
Date: Tue, 30 Oct 2007 17:06:24 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Working frv toolchain?
References: <15675.1193753820@redhat.com> <4726337B.1080608@l4x.org> <4725B553.4060502@l4x.org> <4220.1193663179@redhat.com> <15712.1193753924@redhat.com>
In-Reply-To: <15712.1193753924@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
>> Ah... I'd forgotten about that.  I'm not sure all the ASM constraint changes
>> are upstream yet, and gcc bz 28583 also gets incurred.  Are you particularly
>> interested in building your own compiler, or would one of ours do?
> 
> Look in:
> 
> 	ftp://ftp.redhat.com/pub/redhat/gnupro/FRV

Hmm, I'm needing it for my pet project kernel compile tests at
http://l4x.org/k/. It would be nice to be as close as possible
to the upstream gcc. So patches against gcc upstream would be
welcome...
If you say that ain't happening, I'll just use the precompiled stuff.

Jan

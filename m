Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbZAQH10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbZAQH10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 02:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbZAQH1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 02:27:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39307 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbZAQH1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 02:27:16 -0500
Message-ID: <49718851.9010901@zytor.com>
Date: Fri, 16 Jan 2009 23:27:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: sidc7 <siddhartha.chhabra@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel vs user memory
References: <21512362.post@talk.nabble.com> <49717A28.2060106@zytor.com> <21513615.post@talk.nabble.com> <49717D03.2030205@zytor.com> <21513643.post@talk.nabble.com>
In-Reply-To: <21513643.post@talk.nabble.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sidc7 wrote:
> One last question, which one of the two lowmem or highmem kernel is most
> commonly used on contemporary linux boxes. I am guessing highmem kernel ?
> 
> Thanks for the quick replies, helped a lot

For PCs, 32 bit is generally highmem, and 64 bits is lowmem.  Most
embedded systems are lowmem.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


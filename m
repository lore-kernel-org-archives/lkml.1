Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbYJIRoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbYJIRoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759335AbYJIRoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:44:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55690 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbYJIRoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:44:44 -0400
Message-ID: <48EE4302.2010404@zytor.com>
Date: Thu, 09 Oct 2008 10:44:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [update5] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809090641.m896fscX028849@hitchhiker.org.lu> <48C99F29.2030007@zytor.com> <48C9A6C0.4070802@knaff.lu> <48C9A80D.1010703@zytor.com> <48D73858.3070900@knaff.lu> <48D7C304.4020709@zytor.com> <48D7C48F.8010907@knaff.lu> <48D93E68.6040701@zytor.com> <48D9471E.9090108@knaff.lu> <48D95A8F.10705@zytor.com> <48D95ECC.9010107@knaff.lu> <48D96013.1070507@zytor.com> <48D966E4.7080200@knaff.lu> <48D96B58.6080604@zytor.com> <48D96C60.6000104@knaff.lu>
In-Reply-To: <48D96C60.6000104@knaff.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alain,

Are you planning to submit an updated patch any time soon?  If so, 
please separate the ARM, x86, library and generic portions into separate 
patches.  It looks like at least some of them already went into ARM, 
which makes it impractical to include this as a monolithic patch, which 
it really shouldn't have to be, anyway.

	-hpa

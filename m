Return-Path: <linux-kernel-owner+w=401wt.eu-S934725AbYCFVBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934725AbYCFVBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932428AbYCFVAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:00:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988AbYCFVAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:00:47 -0500
Message-ID: <47D05A70.40008@zytor.com>
Date: Thu, 06 Mar 2008 12:56:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Richard Guenther <richard.guenther@gmail.com>
CC: Joe Buck <Joe.Buck@synopsys.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Haley <aph@redhat.com>, Aurelien Jarno <aurelien@aurel32.net>,
       Michael Matz <matz@suse.de>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
References: <20080305153020.GA24631@volta.aurel32.net>	 <20080305195834.GA17267@synopsys.com>	 <20080305202319.GA17053@volta.aurel32.net>	 <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>	 <47CF0627.2070200@zytor.com> <47CF07FE.10200@aurel32.net>	 <47CFBF28.4060309@redhat.com> <871w6ogjnu.fsf@basil.nowhere.org>	 <84fc9c000803060406u7dfa0d38ve8af3154bf5064f9@mail.gmail.com>	 <20080306173438.GH17267@synopsys.com> <84fc9c000803061254i5865f68ev11fcfd08b698c58f@mail.gmail.com>
In-Reply-To: <84fc9c000803061254i5865f68ev11fcfd08b698c58f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guenther wrote:
> 
> A patched GCC IMHO makes only sense if it is always-on, yet another option
> won't help in corner cases.  And corner cases is exactly what people seem
> to care about.  For this reason that we have this single release, 4.3.0, that
> behaves "bad" is already a problem.
> 

The option will help embedded vendors who can guarantee that it's not a 
problem.

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbXEPPNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbXEPPNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbXEPPN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:13:28 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:41844 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbXEPPN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:13:27 -0400
Message-ID: <464B1F8D.1000500@cateee.net>
Date: Wed, 16 May 2007 17:13:17 +0200
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Bhutani Meeta-W19091 <Meeta.Bhutani@motorola.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Contributor Agreement/Copyright Assignment
References: <7376BC9FD0C11A4CA373508199DEED1802E35A76@de01exm65.ds.mot.com>
In-Reply-To: <7376BC9FD0C11A4CA373508199DEED1802E35A76@de01exm65.ds.mot.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bhutani Meeta-W19091 wrote:
>  
> Motorola would like to understand if kernel.org has a contributor
> agreement (or a copyright assignment agreement) that is posted somewhere
> ? We are investigating what would be needed from a legal standpoint to
> possibly contribute in the future.

For "kernel.org" you mean linux kernel?

In this case: no copyright assignment is required.

The changes should be compatible with GPL v2
(as you will find i.e. in http://lxr.linux.no/source/COPYING )

You should confirm the:
"Developer's Certificate of Origin 1.1".
This is in Documentation/SubmittingPatches
( http://lxr.linux.no/source/Documentation/SubmittingPatches )

Note: IANAL, and I don't speak for other contributors ;-)

ciao
	cate

PS: there is already a copyrighted file by motorola:
include/net/sctp/constants.h
( http://lxr.linux.no/source/include/net/sctp/constants.h )

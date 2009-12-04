Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbZLDK0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbZLDK0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbZLDK0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:26:23 -0500
Received: from paperstreet.colino.net ([213.41.244.236]:54313 "EHLO
	paperstreet.colino.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbZLDK0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:26:23 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Dec 2009 05:26:22 EST
Date: Fri, 4 Dec 2009 11:20:00 +0100
From: Colin Leroy <colin@colino.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] therm_adt746x: Don't access non-existing register
Message-ID: <20091204112000.0cf0b0e7@paperstreet.colino.net>
In-Reply-To: <20091204103434.0a754925@hyperion.delvare>
References: <20091202091951.5ec6bb83@hyperion.delvare>
	<1259894454.2076.1246.camel@pasglop>
	<20091204103434.0a754925@hyperion.delvare>
X-Mailer: Claws Mail 3.7.3cvs10 (GTK+ 2.16.1; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAIVBMVEUAAwASFBYfISMyMTRGRUdaWFdxb2yJhoKrqaPOzMT19Ow5JzfkAAACW0lEQVQ4y6WTP1PbMBjGo6T/RkmmLWxIotCxtkRpmYqVMLAFY2i7AU0DbEDACVOvd6aED9DYnntg61NWCo0tt2N1vpyjn5/30ftIajT+Z4BVLLw3/0w7a+MsVXln8a/5x+E47fXT5FLW55ubP0ZFViTj6KImcXb7l5Pr4XD4JQo3bNDSVdIbLgLhd3ZssLwXHyUXwheACWnXivrx13bHRU3ECHMt6yjsDA8XIWygJsZeBZ5E/mrHBwAgpB9W1XodSw+Dh3cEvA8lODrQVR5i0Q8pTUB0Dq3I3LKTR/3cQyXC5KzM6b1Kugj9+YfI91LxWaUHej1gqsL0vAzkSiUHZqXGFToWuFUTSRHExEiarAsrcO1ThPDUpuVszAC4KgbcI7plQ5q4Cus2Dzh30e72w3ekbCnpSSERXpJGAdhs4Y35ImZiLVNn0y7RyqxzcKvUwDtRKne5JnhuFmJLKXXnZ/p3X0tAZQ4MONUy1UWgAXG1H/rj/HRLA1fbQuCUYN1Ueakp0UkCwMqgW1mhTvFxca67hxDxEoCtvNhHDtd5IQAc65Qs5PcSMbHjasD96iyA+TymlEujcIoza5tfFGlAKOceQm9VYG2/KFRAGeeUoOXUPtRsMupxJrkutTSuXYPonT4MbaNYOq6BlVHAPWEA34O1i5YGQmoPXWsP1a7aeEI5oxRj9LEOtu449SgmBB6FtVpPB9rBDChuagDs8Okg4FVG7Ft7eRKLtmnEWc66Fvg0Wc/boeQu7u6Ovln2PwcL6ZdO2yOrz3ujX6BySA6fpXEovbntcHNwb9x/A34/oQVbOAIKAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009 10:34:34 +0100, Jean Delvare wrote:

Hi,

> $ scripts/get_maintainer.pl --file drivers/macintosh/therm_adt746x.c 
> Colin Leroy <colin@colino.net>
> Grant Likely <grant.likely@secretlab.ca>
> linux-kernel@vger.kernel.org
> devicetree-discuss@lists.ozlabs.org
> 
> This lists Colin Leroy, who apparently doesn't exactly care about the
> driver, but not linuxppc-dev@*ozlabs.org where you say patches should
> be sent.

I'm sorry, I thought I wasn't listed as a maintainer anymore for
this... I don't have the hardware anymore.

-- 
Colin

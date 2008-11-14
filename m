Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYKNCG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYKNCG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYKNCF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:05:59 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:50439 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbYKNCF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:05:58 -0500
Message-ID: <491CDCFF.5010202@euromail.se>
Date: Fri, 14 Nov 2008 03:05:51 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: jg@laptop.org
CC: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
References: <1226585461.6651.52.camel@jg-vaio>	 <491CCC8A.5090109@euromail.se> <1226626758.6651.107.camel@jg-vaio>
In-Reply-To: <1226626758.6651.107.camel@jg-vaio>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1L0o4J-00011w-8a.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1L0o4J-00011w-8a de040581463a2ca97e6aade6f7532cff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Right. :-) I believe the ellipse model is adequate, because it is the
>> simplest model that allows for utilization of the orientation of a
>> single finger, for instance to turn a knob. At this point, it seems
>> like tough enough a challenge.
>>
>
> Maybe; but modeling this as a parallelogram or trapezoid may be easier
> to deal with computationally when you stroke a path from the data, to
> which you may have fit a spline....

I believe the word "ellipse" is taken too literally here. Orientation
and eccentricity are two parameters describing a non-circular
object. I does not have to be realized as ellipses on a screen.

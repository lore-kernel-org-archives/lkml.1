Return-Path: <linux-kernel-owner+w=401wt.eu-S1751450AbXCTQoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbXCTQoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbXCTQoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:44:12 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:42115 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbXCTQoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:44:10 -0400
Date: Tue, 20 Mar 2007 17:42:57 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: UDP packets scheduling
In-Reply-To: <20070320093146.5f208697@freekitty>
Message-ID: <Pine.LNX.4.61.0703201742390.20032@yvahk01.tjqt.qr>
References: <20070320005228.GN22880@mail.muni.cz>
 <MDEHLPKNGKAHNMBLJOLKCEEACGAC.davids@webmaster.com> <20070320093146.5f208697@freekitty>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 20 2007 09:31, Stephen Hemminger wrote:
>> > can anyone suggest me a proper way how to schedule UDP packets to
>> > transmit at
>> > some given rate?
>> >
>> > E.g., I have two boxes both having 10 GE interfaces. One box is able to
>> > transmit at 9.9Gbps, the other one is able to receive only at
>> > about 5.5Gbps.
>> > Flow control must be turned off for some other reason.
>
>  "Those who do not understand TCP are condemned to reinvent it, poorly."

So perhaps, might want to use SCTP?



Jan
-- 

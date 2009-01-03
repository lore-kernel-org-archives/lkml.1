Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbZACOPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbZACOPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 09:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbZACOPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 09:15:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:46060 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988AbZACOPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 09:15:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hQ0QEQo8MCVSXEs4q1yCQuPZSTNRM1KgFM2K23BM5WmVajEQkot1GGYdV5U46adAf/
         OUD2+uDhohU2/1L+wVp+8E/MW1b8d5FHEbVNdnL6NhPgDs0M6HkLAcobj2gsXccX0rAN
         gwJoXW3DCYS5iB6hwXzWBJdZvEdH6R0Cyrt+c=
Message-ID: <195c7a900901030615i19dc95afyab22390fe867e09d@mail.gmail.com>
Date: Sat, 3 Jan 2009 15:15:03 +0100
From: "Bastien ROUCARIES" <roucaries.bastien@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: ath9k microwave anomaly
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090103073051.GC5038@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495ED1C4.8020304@gmail.com> <20090103032134.GA20209@redhat.com>
	 <495EDC10.20605@gmail.com>
	 <f488382f0901021949y60b6d60fjeaeb6bb12a851f8@mail.gmail.com>
	 <495EE2A0.2080703@gmail.com> <495EEE1D.8050500@shaw.ca>
	 <20090103073051.GC5038@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> BTW, having any WiFi stopping working at 30 feet around a microwave oven
> makes me think that beast is leaking like mad. I've already ran experiences
> with mine in the past, and it could only slightly perturbate the traffic
> within one meter (3 ft) which I already considered huge. You may want to
> try to put some aluminium foil on the front door, it is possible that the
> protection grid is damaged or not properly sealed.

Likely not the grid. The grid is pretty solid. I will guess it is the
wave traps seals arround the microwave door (often they are made
rubber part mixed with conductive stuff) that are too old. These seals
tend to expand when hot and are therefore more efficient. You could
change it for cheap ($10), ask our local general store. As a quick fix
(not recommended) you could add some electrical conductive grease but
it will further decreade long term abilty of these seals (grease tend
to crack rubber), and these kind of grease are not really food
compatible.

Bastien

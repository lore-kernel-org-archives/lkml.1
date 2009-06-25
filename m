Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZFYN24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZFYN24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZFYN2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:28:30 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:59882 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbZFYN23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:28:29 -0400
Message-ID: <a4495505aea6a06643c8072fd790fb5d.squirrel@www.hardeman.nu>
In-Reply-To: <20090625141752.740e081d@lxorguk.ukuu.org.uk>
References: <20090624213645.GA18843@hardeman.nu>
    <20090624234501.3d35642f@lxorguk.ukuu.org.uk>
    <55ca74318001aae803805a7bccfaca36.squirrel@www.hardeman.nu>
    <20090625134946.46109bac@lxorguk.ukuu.org.uk>
    <c17c39d3458ffa3aebee03ff26d90c23.squirrel@www.hardeman.nu>
    <20090625141752.740e081d@lxorguk.ukuu.org.uk>
Date: Thu, 25 Jun 2009 15:28:31 +0200 (CEST)
Subject: Re: [RFC/PATCH] Winbond CIR driver for the WPCD376I chip (ACPI/PNP 
               id WEC1022)
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, jesse.barnes@intel.com
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, June 25, 2009 15:17, Alan Cox wrote:
>> Which way of stopping the serial layer from grabbing the port did you
>> have in mind?
>
> You can vanish it with setserial as stands. There isn't a good
> interface for doing that from kernel side but as you can see from
> setserial the infrastructure is all there to add it.

Seems user-unfriendly...wouldn't blacklisting that particular port (using
ACPI or PNP id or something) be a better solution?

-- 
David Härdeman


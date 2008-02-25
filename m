Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYBYLsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYBYLsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYBYLsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:48:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYBYLsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:48:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Date: Mon, 25 Feb 2008 12:47:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080225093914.GB4375@ics.muni.cz>
In-Reply-To: <20080225093914.GB4375@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802251247.30605.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 of February 2008, Lukas Hejtmanek wrote:
> Hello, 

Hi,

Thanks for the report.

> 2.6.25-rc2-git7 has regression, thinkpad keys do not work any more.
> 
> Probably this commit broke things 6c231bd5eb07ce546517019f334652b9ecfc329a

Please always provide the commit subject along with the hash in bug reports.

Also, CCing the author and the relevant list on a report usually is a good
idea. :-)

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZICOei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZICOei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZICOeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:34:37 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:60954 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbZICOeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:34:36 -0400
From: Frans Pop <elendil@planet.nl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2/6] thermal: sysfs-api.txt - document passive attribute for thermal zones
Date: Thu, 3 Sep 2009 16:34:37 +0200
User-Agent: KMail/1.9.9
Cc: Zhang Rui <rui.zhang@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas, Sujith" <sujith.thomas@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl> <1251765882.3483.193.camel@rzhang-dt> <20090902200233.GB1918@ucw.cz>
In-Reply-To: <20090902200233.GB1918@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909031634.38316.elendil@planet.nl>
X-OriginalArrivalTime: 03 Sep 2009 14:34:38.0946 (UTC) FILETIME=[AABFAC20:01CA2CA3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 September 2009, Pavel Machek wrote:
> So '0=disabled'? Better say that, because throttling at 0C would be
> useless in most of the world.

I've addressed this in the new version of patch 4/6 I just sent.

Cheers,
FJP

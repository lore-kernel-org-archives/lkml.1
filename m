Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZG0CbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZG0CbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 22:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZG0CbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 22:31:15 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:64035 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754152AbZG0CbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 22:31:14 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13742] iwlagn (4965): regression when hardware rf switch is used
Date: Mon, 27 Jul 2009 04:31:10 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Reinette Chatre" <reinette.chatre@intel.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.1lD.pHObKB@chimera>
In-Reply-To: <3zAHs5O6maO.A.1lD.pHObKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907270431.13548.elendil@planet.nl>
X-OriginalArrivalTime: 27 Jul 2009 02:31:14.0736 (UTC) FILETIME=[50205300:01CA0E62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 July 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me
> know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13742
> Subject	: iwlagn (4965): regression when hardware rf switch is used
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2009-06-29 11:28 (28 days old)
> References	: http://lkml.org/lkml/2009/6/29/88
> Handled-By	: Reinette Chatre <reinette.chatre@intel.com>
> Patch		: http://lkml.org/lkml/2009/6/30/224

Patch is not yet in mainline.

There are a couple of (minor) open questions in my last mail:
http://lkml.org/lkml/2009/7/1/335

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbZGHAcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbZGHAcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 20:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbZGHAcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 20:32:07 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:62092 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754229AbZGHAcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 20:32:07 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13667] drm: display arifacts when X.Org is stopped
Date: Wed, 8 Jul 2009 02:32:03 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@gmail.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <dWkuWjWDsSB.A.6tE.d0oUKB@chimera>
In-Reply-To: <dWkuWjWDsSB.A.6tE.d0oUKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907080232.04551.elendil@planet.nl>
X-OriginalArrivalTime: 08 Jul 2009 00:32:05.0733 (UTC) FILETIME=[8523C950:01C9FF63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me
> know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13667
> Subject	: drm: display arifacts when X.Org is stopped
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2009-06-27 18:52 (10 days old)
> References	: http://lkml.org/lkml/2009/6/27/105

Problem is still there with -rc2. Dave said he'd try to reproduce, but 
I've not heard back from him yet.

Cheers,
FJP

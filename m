Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbYBMOd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbYBMOd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYBMOdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:33:20 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:21283 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbYBMOdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:33:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qbIOuoCiqVvAzFuqeTP2TMj+mKoCWuPmnzRbupXbV7qhU5MlDnS7YQsk2mPqC05F0pZDevoXwCIZW/PutzC2OZ5jZM1h24Jdifdu4v4scKa0t+Of2daWKJEfgVUpghujzipzs6Rzpq7wUXZanAqSUpY5FAH+3Ny7I3+Smr32c68=
Message-ID: <47B30078.50605@gmail.com>
Date: Wed, 13 Feb 2008 12:36:40 -0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc1 regression - ondemand governor does not work at all
References: <20080213135143.GA4345@ics.muni.cz>
In-Reply-To: <20080213135143.GA4345@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> Hello,
> 
> as of 2.6.25-rc1, ondemand governor from cpufreq (acpi-p states driver) does
> not change frequency. Machine is still running at max frequency regardless of
> system load.

Try the patch here:
http://lkml.org/lkml/2008/2/12/351




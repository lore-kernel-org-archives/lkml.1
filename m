Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbYAQISa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbYAQISa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 03:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYAQISU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 03:18:20 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57569 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbYAQIST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 03:18:19 -0500
Date: Thu, 17 Jan 2008 09:18:24 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       sujith.thomas@intel.com
Subject: Re: [PATCH 9/10] introduce intel_menlow platform specific driver
Message-ID: <20080117081824.GA3284@uranus.ravnborg.org>
References: <1200556278.2935.118.camel@acpi-sony.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200556278.2935.118.camel@acpi-sony.sh.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> +config INTEL_MENLOW
> +        tristate "Thermal Management driver for Intel menlow platform"
> +        depends on ACPI_THERMAL
> +	default n

default n is not needed - it is default.

	Sam

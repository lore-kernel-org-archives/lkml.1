Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951AbYCLJQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbYCLJQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 05:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYCLJQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 05:16:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58587 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYCLJQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 05:16:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47D79F3E.60803@s5r6.in-berlin.de>
Date: Wed, 12 Mar 2008 10:15:42 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] firewire: debug AT, AR, and selfID-complete events
References: <tkrat.f96c4067f6a48f4a@s5r6.in-berlin.de> <200803100047.05387.jwilson@redhat.com> <tkrat.ebca3f78fa768606@s5r6.in-berlin.de>
In-Reply-To: <tkrat.ebca3f78fa768606@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> +MODULE_PARM_DESC(debug, "Verbose logging (default = 0"
> +	", self-IDs = "		__stringify(OHCI_PARAM_DEBUG_SELFIDS)
> +	", AT and AR events = "	__stringify(OHCI_PARAM_DEBUG_AT_AR)
> +	", or a combination)");

Interrupt event logging needs to be added as well.
-- 
Stefan Richter
-=====-==--- --== -==--
http://arcgraph.de/sr/

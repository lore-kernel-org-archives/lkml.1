Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbYDKGGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbYDKGGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 02:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbYDKGGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 02:06:41 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:62290 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbYDKGGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 02:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=g5As99ZgoG6yBWVqEDT8CCzW0rycMpHPZymMmUEN9x9fpfVBKjVrDe6W7CT0QSyeiaQTT15CE7YiAZI8Xt+miBNiggo4O6dq3M4S7DWeHBQaVN1GCCrm5cNXZD/0GTjO6iOJqSOMaQwUfuFmiAtwSHUgVWSFFB8Abu6yFONTSK4=
Message-ID: <47FEFFD6.3070902@gmail.com>
Date: Fri, 11 Apr 2008 15:06:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peer Chen <pchen@nvidia.com>
CC: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kuan Luo <kluo@nvidia.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803191455.14380.volker.armin.hemmann@tu-clausthal.de> <47F30438.40506@gmail.com> <200804021909.41609.volker.armin.hemmann@tu-clausthal.de> <47F43766.2070207@gmail.com> <15F501D1A78BD343BE8F4D8DB854566B2600DE6E@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B2600DE6E@hkemmail01.nvidia.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peer Chen wrote:
> I didn't find this issue on my MCP65 board but my chip revision is
> 0xa3 and yours is 0xa1, I'll try to find if there is any useful
> information between two version chip for this issue.

Any progress?

-- 
tejun

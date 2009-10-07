Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbZJGV4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbZJGV4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbZJGV4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:56:04 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:58683 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZJGV4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:56:03 -0400
Message-ID: <4ACD0DA9.2090707@nortel.com>
Date: Wed, 07 Oct 2009 15:52:41 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Niels Roest <niels@directfb.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: DirectFB "Fusion" module inclusion?
References: <4ACC917D.3090302@directfb.org>
In-Reply-To: <4ACC917D.3090302@directfb.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2009 21:54:59.0638 (UTC) FILETIME=[D0C0D560:01CA4798]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2009 07:02 AM, Niels Roest wrote:
> Hi all.
> 
> This is to request some comments about our interest to have our "Fusion" 
> kernel module included in the kernel.
> I hope you will let me now if it is feasible, desirable, etcetera.

My initial reaction is that aside from everything else the naming is
unfortunate since there is already a "Fusion" device driver, controlled
by the CONFIG_FUSION config option.

Adding a new CONFIG_FUSION_DEVICE for something totally different seems
ripe for confusion.

Chris

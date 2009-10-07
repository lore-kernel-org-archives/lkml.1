Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbZJGSID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbZJGSID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759889AbZJGSIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:08:01 -0400
Received: from claw.goop.org ([74.207.240.146]:38071 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759293AbZJGSIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:08:00 -0400
Message-ID: <4ACCD8DA.4030305@goop.org>
Date: Wed, 07 Oct 2009 11:07:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Allen Kay <allen.m.kay@intel.com>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, matthew@wil.cx, chris@sous-sol.org,
       don.dugger@intel.com
Subject: Re: [ACS PATCH v5 2/2] adding xen dom0 checking
References: <1254936471-18602-1-git-send-email-allen.m.kay@intel.com>
In-Reply-To: <1254936471-18602-1-git-send-email-allen.m.kay@intel.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/09 10:27, Allen Kay wrote:
> This patch is predicated on Jeremy's patch in include/xen/xen.h.
>   

Feel free to include that patch in your series if you depend on it. 
Otherwise it will get too awkward keeping track of everything.

    J

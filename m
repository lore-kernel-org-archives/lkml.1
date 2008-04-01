Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbYDASSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbYDASSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 14:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbYDASSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 14:18:10 -0400
Received: from mail.vyatta.com ([216.93.170.194]:58936 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539AbYDASSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 14:18:09 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.996
Date: Tue, 1 Apr 2008 11:18:02 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
Message-ID: <20080401111802.65fe259f@extreme>
In-Reply-To: <200804011107.38563.inaky@linux.intel.com>
References: <200804011107.38563.inaky@linux.intel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008 11:07:37 -0700
Inaky Perez-Gonzalez <inaky@linux.intel.com> wrote:

> 
> Intel would like to announce the initial release of a Linux WiMAX 
> common stack and drivers for its WiMAX devices (eg: Intel(r) 
> WiMAX/WiFi Link 5050, with estimated availability around third 
> quarter of 2008).
> 
> The project follows a standard layered approach: a generic WiMAX 
> kernel stack provides a common interface to control WiMAX devices. 
> A user space daemon and libraries provide a high level API for 
> control (network scanning, connection, disconnection, roaming 
> management, etc) and access to the drivers. 
> 
> Currently much of this higher level code is tailored to Intel's 
> device, but we wanted to get it out as soon as possible.
> 
> You can find the code and additional information at
> http://linuxwimax.org.
> 

Code review occurs on patch submittable not by pointing developers off
to an external project. Most likely there will be feedback that requires
changes to API and other choices so you want to do this soon.

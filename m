Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYJNJuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYJNJuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYJNJuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:50:08 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:47100 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYJNJuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:50:07 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Nicolas Bareil <nico@chdir.org>
Subject: Re: USB problem on x86_64: nommu_map_single() issue?
Date: Tue, 14 Oct 2008 11:48:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20081014072045.GA1252@sd-5945.dedibox.fr>
In-Reply-To: <20081014072045.GA1252@sd-5945.dedibox.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810141148.48220.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 14. Oktober 2008 09:20:45 schrieb Nicolas Bareil:
> Hi
> 
> On 2.6.27, I can't use any USB device (mass storage, mouse) anymore on my x86_64 system, the devices
> are not detected: lsusb returns nothing except the hub.

Is this a regression? Did it work on earlier kernels?
> 
> I have the following logs in kern.log when booting with my USB mouse plugged :

For confirmation boot with mem=2G on the kernel command line?

	Regards
		Oliver

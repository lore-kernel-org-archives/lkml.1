Return-Path: <linux-kernel-owner+w=401wt.eu-S1751386AbXCUIFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbXCUIFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 04:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbXCUIFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 04:05:38 -0400
Received: from tyholt.uninett.no ([158.38.62.9]:53542 "EHLO tyholt.uninett.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbXCUIFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 04:05:37 -0400
Message-ID: <4600E74E.7020606@uninett.no>
Date: Wed, 21 Mar 2007 09:05:34 +0100
From: Jon K Hellan <jon.kare.hellan@uninett.no>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
References: <20070321074121.GA13843@enneenne.com>
In-Reply-To: <20070321074121.GA13843@enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti wrote:
> Pulse per Second (PPS) support for Linux.
> 
> Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
> 
> ---
> 
> Please, note that this PPS implementation is not RFC 2783 fully
> compatible since, IMHO, the RFC simply doesn't consider PPS devices
> connected with special GPIOs or other ports different from serial
> ports and parallele ports.
>

Have you received any comments on this from the NTP community? From 
Ulrich Windl?

Jon Kåre Hellan, UNINETT, Trondheim, Norway

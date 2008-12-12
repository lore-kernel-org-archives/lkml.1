Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbYLLQPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbYLLQPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbYLLQPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:15:33 -0500
Received: from smtp-04.mandic.com.br ([200.225.81.151]:56886 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbYLLQPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:15:33 -0500
Message-ID: <49428DF8.2090205@diamondcut.com.br>
Date: Fri, 12 Dec 2008 14:14:48 -0200
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: faraohh@gmail.com
Subject: Re: Auto generate .config.
References: <f5cc88f60812120747w47c762a7qcee62fdfa10d6ac6@mail.gmail.com>
In-Reply-To: <f5cc88f60812120747w47c762a7qcee62fdfa10d6ac6@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcello Henrique wrote:
> How make to generate the file .config from my distribution to compile
> new optimized kernel?

Marcello, default .config file of your distro can be founded in /boot
directory in something like this: "config-2.6.26".

Just rename it to .config and move it to your kernel source directory.

Best regards,
Renato

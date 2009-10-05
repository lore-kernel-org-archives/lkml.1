Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZJEQlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZJEQlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 12:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZJEQlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 12:41:08 -0400
Received: from poutre.nerim.net ([62.4.16.124]:56165 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbZJEQlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 12:41:08 -0400
Date: Mon, 5 Oct 2009 18:40:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Brad Campbell <brad@wasp.net.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
Message-ID: <20091005184018.5655090e@hyperion.delvare>
In-Reply-To: <68676e00910050837g2006bfb8j349891504e474a95@mail.gmail.com>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
	<68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>
	<4AC939BB.8090600@wasp.net.au>
	<68676e00910050837g2006bfb8j349891504e474a95@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009 17:37:29 +0200, Luca Tettamanti wrote:
> That's good ;-) The driver is quiet when everything is ok. You should
> see the corresponding entries under /sys/class/hwmon/hwmonN; upgrade
> lm-sensor package to version 3.1.1, older versions do not support ACPI
> devices.

Actually lm-sensors version 3.1.0 did already support ACPI devices. But
there's no reason to not upgrade to 3.1.1.

-- 
Jean Delvare

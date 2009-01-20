Return-Path: <linux-kernel-owner+w=401wt.eu-S1762174AbZATSUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762174AbZATSUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZATSUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:20:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:11718 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZATSUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:20:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=nD2KayW2efNXGqYWaPxB02K6N2qCFc+ZqI8rseVInugsNVw7xLr7vuSreSKzk1mDhr
         uqMfuh2hWP8ORAdW0NnW7ydQSbA5FtJ0Gw0zFoXKBXEs62Sw3JJUT4zk+/B+GS+kxWR/
         CeE6bP19FpIm8NQ4UiWdbAagsio0skAjgWKJs=
Date: Tue, 20 Jan 2009 19:18:36 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Faulty seagate drives, are going to be blacklisted?
Message-ID: <20090120191836.71582cbe@diego-desktop>
In-Reply-To: <125975.1232472247@turing-police.cc.vt.edu>
References: <20090120002923.065f24ca@diego-desktop>
	<85346.1232422345@turing-police.cc.vt.edu>
	<20090120163028.63efeb1a@diego-desktop>
	<125975.1232472247@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 20 Jan 2009 12:24:07 -0500, Valdis.Kletnieks@vt.edu escribió:

> Probably a better approach, as long as we leave enough info visible in various
> /sys files for HAL to figure it out - but I'm pretty sure we already do that...

Yeah, it's all there already, and HAL has support for it. It just needs
the neccesary .fdi files.

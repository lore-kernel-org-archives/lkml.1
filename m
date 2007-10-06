Return-Path: <linux-kernel-owner+w=401wt.eu-S1764578AbXJFCMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764578AbXJFCMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 22:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXJFCMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 22:12:13 -0400
Received: from smtp102.sbc.mail.re2.yahoo.com ([68.142.229.103]:23797 "HELO
	smtp102.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751582AbXJFCMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 22:12:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=ysOWQyMbi7g+/EKZx+821t9KIfMVnqxICmJO2HhaSt/wZ5AUPup1qmpkM9odamxFHunVRxdTjRe7yN8fx6k5yCk/DnQh0C9n8nx0/YD4eFy1Gp6uf1lpeHr0vjCUoh6o8N9WekA1/Sw52MSv9lD8cXOA5Ep2ABhKvKhIrUhaEm0=  ;
X-YMail-OSG: HriqcBwVM1ltmMOvMGIYBTCxlS4lBka2gnhHIWZn_D_sBxET
Date: Fri, 05 Oct 2007 19:12:16 -0700
From: David Brownell <david-b@pacbell.net>
To: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [Patch]Documentation/spi/spidev_test.c: constify some variables
Cc: spi-devel-general@lists.sourceforge.net, avorontsov@ru.mvista.com,
       akpm@osdl.org
References: <20071006020229.GB2436@hacking>
In-Reply-To: <20071006020229.GB2436@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071006021216.AA2D0239BAC@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: WANG Cong <xiyou.wangcong@gmail.com>
>
> Constify two char pointers and a struct in Documentation/spi/spidev_test.c.
>
> CC: David Brownell <dbrownell@users.sourceforge.net>

ACK

> CC: Anton Vorontsov <avorontsov@ru.mvista.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>

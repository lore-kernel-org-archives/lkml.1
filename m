Return-Path: <linux-kernel-owner+w=401wt.eu-S1946292AbXBPXht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946292AbXBPXht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946303AbXBPXh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:37:26 -0500
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:45952 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1946301AbXBPXhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:37:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YAQRSp4CRNX7q3+fT0oK29BhPxmeTl2Ae5cYY5VrY40hZkuPRjECSAwsRuCJiWZs5/KQFl3CBv2Ess+MgZMiG3vLUgDitjX/jNfMzSSZMjLJcUNzU0z7WKkKi2VWHOeowKDjpTTfNN3zQuNq1ipwECmG8Ha130aPRn8PQgTvsBU=  ;
X-YMail-OSG: DSzIUQoVM1l9TU5U_euYX1HB_oewfJK79JU15OMPrlQP5H9DNco6H1BGVvISTolgl_oBPIm7kHBUWyFgcu9mpSHVeCzpQdGgoQPK0.gBm7AK2ybr75393wv7IvsRzYFIvPiZgj_R8WVp4w--
From: David Brownell <david-b@pacbell.net>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] usbnet/rndis (was: Is this bug too obvious?)
Date: Fri, 16 Feb 2007 15:37:20 -0800
User-Agent: KMail/1.7.1
Cc: Pete Zaitcev <zaitcev@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <45D25ABE.5080400@redhat.com> <45D26222.9040504@redhat.com> <20070216143446.a2134b3c.zaitcev@redhat.com>
In-Reply-To: <20070216143446.a2134b3c.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702161537.21045.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If you don't do it sooner, I'll look at the error paths in rndis
> and/or usbnet.

Try that patch I sent by this morning.  ISTR getting some
positive reports from that...

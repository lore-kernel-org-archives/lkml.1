Return-Path: <linux-kernel-owner+w=401wt.eu-S935243AbYBUBdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243AbYBUBdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761322AbYBUBdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:33:12 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:23153 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757761AbYBUBdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:33:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=S1n4aYyQ0AfQt3BwB1s00lk3rkHzX8UKuPYnPcyag5oLaxddJI4HNNFMOquFs4rySPBEPAFUQ5gAYw4wwrnAPAlQrA0ARVmBYQTPJYd8tP1Td4VIzaF+ihqAldIBMYClAhLPfTKU8Kd8xUZ2MeFGjkROxE94/tbyzCHby47I9Sg=  ;
X-YMail-OSG: Ih_5W5QVM1nOyQsFX2a61cRVEzeYaHt19f1KM2KbbAnO67Oao4ibqn0SPiik2oI3WlG6FG0rMQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: atmel_spi clock polarity
Date: Wed, 20 Feb 2008 17:33:09 -0800
User-Agent: KMail/1.9.6
Cc: hskinnemoen@atmel.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <20080218153158.2ff8842a@dhcp-252-066.norway.atmel.com> <20080220103446.1621c81f@dhcp-252-066.norway.atmel.com> <20080220.185045.08317377.nemoto@toshiba-tops.co.jp>
In-Reply-To: <20080220.185045.08317377.nemoto@toshiba-tops.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802201733.09451.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008, Atsushi Nemoto wrote:
> > David, do you want me to pass on the patch with my signoff or just ask
> > Andrew to add my Acked-by to the patch already in mm?
> 
> The patch in mm also lacks my Signed-off line.  I had thought Andrew
> never take a patch without Signed-off line ;)
> 
> Should I resend my patch with my Signed-off and Haavard's Acked-by?

Good point.  I think that's the way to go.  

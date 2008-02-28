Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbYB1VVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbYB1VVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYB1VUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:20:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:43341 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbYB1VUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:20:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZSQHd6+nZjKAUA1Lb1BwwIMIMSs4UbNSkteyRXVSspJpc6vOJOsD4/Y0rvD/SYllMHBlrboapLaz1UKSBm3HrXkVtx7/tizJP+MVcPu53cVVN9X4yMCEohj+LFw2NYwafdZHLkPBZGB7biX7fTAOaw/pRyyJfuK/2tNQ3XCF7vA=
Message-ID: <b6fcc0a0802281320u5bc0fb3fga3ee73f0946ff845@mail.gmail.com>
Date: Fri, 29 Feb 2008 00:20:48 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] CodingStyle: multiple updates
Cc: "SL Baur" <steve@xemacs.org>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>, ricknu-0@student.ltu.se,
       bhalevy.lists@gmail.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080226213432.1388717b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204062430.47c488def40a4@portal.student.luth.se>
	 <20080226135444.f83a0536.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0802270033310.5714@axis700.grange>
	 <m31w6zcm4l.fsf@maximus.localdomain>
	 <ed10ee420802261657w3830e1a1rf0cc9601cdacb142@mail.gmail.com>
	 <20080226213432.1388717b.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/08, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> I would gladly NAK it, but most recent email from Linus about
> coding style is that we are getting too detailed about it,
> so unless there is some overwhelming need to change anything in
> CodingStyle, I'm for no changes (or maybe even some removals).

Amen!

CodingStyleForDummies is long overdue...

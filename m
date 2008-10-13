Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbYJMJq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbYJMJq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760963AbYJMJhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:37:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:18006 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760966AbYJMJhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:37:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ILMVvvqkQRYqjcdT4N3zBEXokede8kGr/ABBgHIgwAzp1x3kaU0LhS4bZmbwzJlN8b
         u9tgxzADT4aW/wK+y+6+3acu5fk2Ydkpc/a85CsdpPReKjX5vrc0+9xPs2tZdpiywHF2
         IuvmXX1A3fSTVRDOJT4DR/RAHAkUWOlEdo8qc=
Message-ID: <c62985530810130237t44dc341s2806d106e6f83a7b@mail.gmail.com>
Date: Mon, 13 Oct 2008 11:37:34 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] tty: remove the BKL in n_tty.c
Cc: "Ingo Molnar" <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081013102458.3161441d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081013084719.03972D1B9DE@perso1.free.fr>
	 <20081013102458.3161441d@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/13 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> There are patches pending for this already along with other n_tty
> ordering fixes, they will enter the ttydev tree once the current ttydev
> tree reaches Linus.
>
> Alan
>

Ok thanks.

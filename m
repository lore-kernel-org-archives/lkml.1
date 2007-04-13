Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbXDMGfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbXDMGfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 02:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbXDMGfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 02:35:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:8734 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbXDMGfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 02:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b1W6Fh8/4SJk5Diam89hiJzJmvGRKs3nPa5pbYFg+B8DNN9bhf8cq5/okTnQpPL0X1P5UpyudN+LhbY1l091pBnW0C/Yp+dF6HSp6z2bHpV86Vk2TtGqtZtklZr4AIXUu8ZqYi3zaiFFW/5gH1ulfWLkuoMd6HGwhW9Gy3tLP7g=
Message-ID: <698310e10704122335t7cc42546pe1468d4d25fdd9d4@mail.gmail.com>
Date: Fri, 13 Apr 2007 10:35:40 +0400
From: "Marat Buharov" <marat.buharov@gmail.com>
To: "=?KOI8-R?B?5MXOydMg68nS2NHOz9c=?=" <kirjanov@gmail.com>
Subject: Re: 2.6.20.6 vanilla does't boot
Cc: "Marc Donner" <Marc.Donner@dbd-breitband.de>, linux-kernel@vger.kernel.org
In-Reply-To: <a872555b0704122246n7be574e7mc53920d6e446f86@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a872555b0704122234m6f26405l293dd39f8af672b6@mail.gmail.com>
	 <C244E4A2.1CF94%Marc.Donner@dbd-breitband.de>
	 <a872555b0704122246n7be574e7mc53920d6e446f86@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [17179569.184000]   >>> ERROR: Invalid checksum
Seems like you have buggie bios. As the workaround try to start your
kernel with noacpi parameter.
Solution: Upgrade the BIOS firmware with the latest version available from the
manufacturer.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbXJAIaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbXJAIaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 04:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXJAIaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 04:30:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:18123 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbXJAIaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 04:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=n3WLlTO9vySaTg6AhgrjultXmlm67/yRpVYdo3Wap5RLeD0kvtOPetXE1Y5QMOnRWKjqtaUpPARnk3hut/TqKjMVaZu47ZzAuIH6Rktqp8ny8AKuYfUQgMIaJXoZURqp6Cg8m9Bo0sb7GgTei6J11bP4zQpW1rrsAbMEan+Q55s=
Message-ID: <4700B00A.6090403@gmail.com>
Date: Mon, 01 Oct 2007 10:30:02 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Miguel <mc354@tid.es>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: software unplug and plug USB
References: <46FCF0F5.9030004@wpkg.org> <1191224165.6014.12.camel@McM> <4700A44C.2010700@wpkg.org> <1191226692.6014.16.camel@McM>
In-Reply-To: <1191226692.6014.16.camel@McM>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2007 10:18 AM, Miguel wrote:
> but only when I unplug and plug manually, the modem starts up ...
> Because of that i wanted to unplug/plug via scripting (software way)

You might try this (bottom of the page):
http://lkml.org/lkml/2007/5/28/193

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University

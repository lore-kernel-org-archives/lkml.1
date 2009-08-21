Return-Path: <linux-kernel-owner+w=401wt.eu-S932986AbZHVAHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbZHVAHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 20:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932587AbZHVAHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 20:07:23 -0400
Received: from relay-1700.imt-systems.com ([77.237.241.226]:55037 "EHLO
	relay-1700.imt-systems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755607AbZHVAHW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 20:07:22 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Aug 2009 20:07:22 EDT
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: Michal Schmidt <mschmidt@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 22 Aug 2009 01:57:55 +0200
Subject: RE: DomU crashes during xenfb initialization
Thread-Topic: DomU crashes during xenfb initialization
Thread-Index: AcoiS4QLdM00ZBePQYi6xiHfhJsQJwAbwU/w
Message-ID: <520B2A28AACEE94388C511BBB834933707BF0F4312@IGR-IMC-01.corp.win-professional.com>
References: <20090821124059.17ab93fa@leela>
In-Reply-To: <20090821124059.17ab93fa@leela>
Accept-Language: de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/21 Michal Schmidt <mschmidt@redhat.com>:
> Hello,
>
> Fedora Rawhide kernels do not boot for me under Xen. It is reproducible
> with current vanilla kernel too.
>
> The guest seems to panic, though the panic message does not make it to
> the console. Examining the guest with xenctx gives:

Hello,

I have exactly the same problem with 2.6.31-rc6. (vanilla kernel)

--

Morten

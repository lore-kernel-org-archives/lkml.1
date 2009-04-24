Return-Path: <linux-kernel-owner+w=401wt.eu-S1751064AbZDXTIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064AbZDXTIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZDXTIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:08:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:58435 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZDXTIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=HjIzmgrPTMC/5FxAlXpfkBuB00Yw4Ljv0RR15wJmO4UbVoW+L2+jW6cUUIL/RGL9kS
         EKp2k/1isXBW1L5v5ZqXMMSwMyaCFul5UA+cm55m/ZRCRfS9c6KgvIFiQ9meJwSIuwSX
         r0d/9XfDiq92hBn0jt5Rc79qbX5JfTAa3O+s8=
MIME-Version: 1.0
Date: Fri, 24 Apr 2009 22:07:59 +0300
Message-ID: <54adcfed0904241207o13ec1568xeeac4dbe232621ce@mail.gmail.com>
Subject: Kernel 2.6.28-11 in Ubuntu
From: =?ISO-8859-7?B?xOXz8O/03Orn8iDX8d7z9O/y?= <despotakisch@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I upgraded from Ubuntu 8.10 to 9.04 (jaunty) and the usb radio
avermedia that i have doesn't work in kernel 2.6.28-11 while it works
in kernel 2.6.27-14. It also worked in Ubuntu 8.10 in all kernels. The
problem is probably that there isn't any hiddev device nodes in
/dev/usb/ that the program needs to work when I plug-in the device.

Can anybody to help me.

Thanks.

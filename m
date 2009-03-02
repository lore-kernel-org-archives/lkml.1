Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZCBNjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZCBNjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZCBNjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:39:44 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:23670 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZCBNjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:39:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=mNhDgwn+4DcMBvlzbNrkpc2kv2kIRkYGiMiTm1VnQQFOVfOK0p1MYxWolX9iQupOOa
         gdVLkQ/tPqL+MfFoQoJgE982GY+M8rVbSniBdrHDMdkSZ29uXxo3VAMaXMzQz3SDNLEX
         wQMxwB6RuNMhhrHQDFZH3wozBQUreV1rbHs0U=
MIME-Version: 1.0
Date: Mon, 2 Mar 2009 15:39:41 +0200
Message-ID: <20831c740903020539h68f62f2fj1575408d89050d25@mail.gmail.com>
Subject: usb hotplug and hooking
From: Oguz Yarimtepe <comp.ogz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to run an application when an external usb flash disk is plugged to
my box machine that has STLinux installed in it. My aim is to check some
issues on usb disk, whether it has an official software or not. I am not
sure how will i hook my own application that will check usb device
when it is plugged. I don't want the application run at the
background, but run only when a plug is occured.

Will be happy if you guide a little.

Thanx.

--
Oðuz Yarýmtepe
www.loopbacking.info

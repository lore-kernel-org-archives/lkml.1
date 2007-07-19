Return-Path: <linux-kernel-owner+w=401wt.eu-S965149AbXGSQTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149AbXGSQTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938269AbXGSQTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:19:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:56905 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938046AbXGSQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rS4b2q13pjwIe3qXMeMM9IMAdv0MuC46XTb8s4k5o/DxS81+hkkjmmnJyp6Aehphdw5FA//kvAFvI+OHyTh910aGG/gE9pD7BWsq6PM96ZVBIG3S+FdiGZtLNbMH98ezm15BW0sw7bqWMRK1QcO3Xsl+3/R7j9Qe7AGkae2awkM=
Message-ID: <1a297b360707190919v510ba8b3t90ddf4d19313351e@mail.gmail.com>
Date: Thu, 19 Jul 2007 20:19:07 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: D state
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When a device is in D3 state, is it possible to read from the PCI
config space header ? Or does a D3 state imply that the whole PC
itself is in standby ?

I am trying to relate whether a device that i have, a new device that
i am working upon, starts up in D3 state. whether that could be the
cause of some weirdness.

Thanks,
Manu

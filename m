Return-Path: <linux-kernel-owner+w=401wt.eu-S933923AbXGLM6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923AbXGLM6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759358AbXGLM6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:58:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:15704 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759284AbXGLM6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:58:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tWBzdVk0VkbW+4hu12c6op0JlZIIkPF90ItBnM3tBVTLcYO6EJs8CRY5VJQTRdXPSEaSYhRSfYob3P09zPk4JkADj2sRSShJyyWdaDGvlV97nbKp5fd9Fxfr4gF3wVqcEcNRSIbQgv3YpY6ox9aZ5AyEl1q0yQRdEBIRf9Nc0Jc=
Message-ID: <a9e22dff0707120558k17ca1f86rb0044096d60c4dc1@mail.gmail.com>
Date: Thu, 12 Jul 2007 15:58:34 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Fwd: NPTL
In-Reply-To: <a9e22dff0707120557t574f9383g5363c26074ea6d6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a9e22dff0707120518t77d440d3ue0368fd1f3e36c03@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKCEOCFDAC.davids@webmaster.com>
	 <a9e22dff0707120537l1a29de93vdd67f146cf36a120@mail.gmail.com>
	 <1184244078.20032.48.camel@twins>
	 <a9e22dff0707120557t574f9383g5363c26074ea6d6a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>BTW, please do _NOT_ top post!
sorry

>>No, a process also contains an address space.
Of course .. I ment they are _almoust_ similar.

>>No, that is creating a schedule unit (task) without an address space.
Ok, I've already found that in kernel code ... and correctly understood.

>>Surely you need some context switch when switching between runnable
contexts.
Hm. If the thread is running after it's sister or parent process - you
do not have to switich the process context. Is this done in kernel??

Sorry if my thought are idiotic .. I'm a newby and trying to
investigate the kernel.

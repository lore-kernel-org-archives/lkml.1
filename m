Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZFBWrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZFBWrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZFBWom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:44:42 -0400
Received: from static-ip-85-25-59-232.inaddr.intergenia.de ([85.25.59.232]:49483
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbZFBWol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:44:41 -0400
Date: Wed, 3 Jun 2009 00:44:38 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1634884154.20090603004438@eikelenboom.it>
To: linux-kernel@vger.kernel.org
Subject: Re: Xen is a feature
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So the conclusion would be that for inclusion in mainline:
-The xen dom0 interface should be clean, and the code self contained
-Backwards compatibility of the hypervisor is no argument to include
anything in mainline (and if desired, should be realised in the hypervisor
by (temporarily) supporting the old abi for the current xen specific
kernels and one for the mainline kernel, and thus placing the maintenance
burden of that desire on Xen and not the Kernel)

--

Sander


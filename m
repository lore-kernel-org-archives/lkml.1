Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYIRR5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYIRR5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbYIRR5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:57:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:20224 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbYIRR5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:57:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=a8RU/sTMPw8oxcHlt4ZgHy/KtYqxEu+y4Kt6Y2HUtxg5XUf0trBhz7q6Fpoe7NuBGl
         +krgxFFwj7HvLpWioOkh8EPP0Figkztah/O7faJbSd0+pggKo3G4VmYxfwtVCOkvSRTt
         z+fk6r63Jsqsd0ECUvWgo1rIoJuCsNVmKz3fQ=
Message-ID: <3baf3d760809181057o5810f975w15647878a3033b30@mail.gmail.com>
Date: Thu, 18 Sep 2008 23:27:30 +0530
From: "Singaravelan Nallasellan" <singaravelann@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Interrupt Handler Invocation
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am currently assuming that the ISR will be invoked repeatedly till
the ISR says the IRQ is handled.  Is it a valid assumption?
Can somebody throw some light on whether ISR is invoked repeatedly
when the ISR returns the IRQ is not handled?

What is the behaviour for edge or level triggered interrupts?

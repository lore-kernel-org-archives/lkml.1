Return-Path: <linux-kernel-owner+w=401wt.eu-S1761348AbYARNor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761348AbYARNor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbYARNoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:44:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:41015 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbYARNoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:44:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=SQTKHRePtKNRaj1sHzyNtI2q3YHY8gxULEqd+1eTiBhYfBua2idj/5PEA+Skn4U1Rp7MadUyCVypOTUPhMCsWSF89GoiJGxsArR4v3cRit7s+ZORtFeBcnDy5Zf9vUDYahIj6SmJweOsJHPuOEYJrBG+1yQaM1I2gLMs5Kg4tq4=
Message-ID: <38b2ab8a0801180544j2022af8bl252a118a295b1f34@mail.gmail.com>
Date: Fri, 18 Jan 2008 14:44:38 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: rostedt@goodmis.org
Subject: Why not creating a GIT RT tree ?
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Maybe I missed it but I'm wondering why GIT is not used for
the RT development ? I can't find a rt tree anywhere and all
new rt release spoke about a patchset to apply on mainline
kernels.

Another question, is there a TODO list somewhere which would
help to port the RT patch to a new architecture ?

Sorry if the questions are dumbed but I'm just new to this
project.

Thanks
-- 
Francis

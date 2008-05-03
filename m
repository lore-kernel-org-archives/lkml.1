Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbYECX33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbYECX33 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYECX3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:29:22 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:26437 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYECX3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EwUx+9zI5hnSNkOWR377jN+R+hXfZrRCCDt5ntJziwIxAhBmYsGgzpGMypO2U9wX/dZOsWgMv/VnglRsiOvPiPEMfkZMO0ppw7Hc5LhpCZceHsTTIWREh71WX1q75zK4guIiJmSD3P0fOSPzbXZlB72ykZGupPvbEllFwV8KSbQ=
Message-ID: <dd18b0c30805031629x5f570b97q43f110b228054a28@mail.gmail.com>
Date: Sat, 3 May 2008 23:29:20 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: npiggin@suse.de
Subject: nopage mm.h
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I have a question about the nopage function that was removed in
the kernel.
What would be the best way for me to build a module that has a nopage
funtion in it?
Right now I went and undid what you had done to the kernel,to atleast
have the module not give me errors,
but, am wondering if I should try to take the module and remove the
nopage function in it , and add the functions that is relevent.
to keep the module up-to date.
regards;

-- 
Justin P. Mattock

Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbYBNAIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbYBNAIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbYBNAIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:08:30 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:48220 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbYBNAI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:08:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dsFfbOTM5FWX1YfDeCWMCnqOXoLtfOR2eBZPm3bPBujC4CoZ4z9x+sLcRXLXXPGZ/ENqHcuGewlXiYNUPvy2v+FuRmevIyZz+u66huhM2DDd2CKBJ0czolp5nO4Phh9ZzUtXFVgf0TltoAzdDlGyR7qdKCa5UE2xuQev+efRHCk=
Message-ID: <9a8e2be0802131608m7eef61efmaee332a661503f39@mail.gmail.com>
Date: Thu, 14 Feb 2008 01:08:28 +0100
From: "=?ISO-8859-1?Q?Ricardo_J._Rodr=EDguez?=" <ricardo.rdez@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Semaphores with timeouts
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,
I'm developing a driver to support a new protocol on the kernel 2.6.x,
a real time communication protocol used in robotic fields. Skipping
the intro: I need to know if there is any function in the kernel to
get the process sleeping, as down_interruptible(...), but with
timeouts, I mean, I want the process to wake up if no signal is
detected in a while...

Thanks anyway,
-- 
Ricardo J. Rodríguez
www.deathhc.tk

#329385 | [Registered Linux User]

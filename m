Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbYFWJTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbYFWJTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYFWJTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:19:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:21807 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbYFWJTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Qcd4k00BIpBpMVfizG6bX8gEDVxkq5qCBkEOCBJ7pimCl4WiO0PgdVZ5zavOo8flCY
         +rzRcf5t9K+kzdtJ0EIvId/Dh1VYMKgOiIh0KHkg8STcDEy7XAB/nrk40CTMbuwxAJrT
         DpfsbTelgjBpO6eP1NAslFHB1b+70OVSIEaw8=
Message-ID: <ca0148c30806230219n4dd215efmd1e558cd71b5a0d9@mail.gmail.com>
Date: Mon, 23 Jun 2008 12:19:01 +0300
From: "Matti Linnanvuori" <mattilinn@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com
Subject: [patch v1.2.30] wan: add driver retina
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is on top of linux-next June 20:

http://pcidriver.googlegroups.com/web/retina-1.2.30.patch?gda=9LTzX0QAAAD13nxGN0cierCNeIeJfDX5p-pwqTbkRgzkBArQ5qrYwmG1qiJ7UbTIup-M2XPURDRq8_821R16ifB1rcxxJndoIvUJau0VvnTEe9ncJ6VTfQ&gsc=vaFbWwsAAACowdfl9PxIXcZcOvDNBLUE

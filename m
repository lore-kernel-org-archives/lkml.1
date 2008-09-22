Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbYIVIyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbYIVIyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 04:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYIVIyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 04:54:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:1703 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbYIVIyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 04:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=dRveYXZtLyKoT0faxHR4RJBXd0c1Cyf2yc6HqI8J2IO1nzXlcvdWOh5RxpM1aMahzE
         8LPpYdKxbx4xRLGielfyRTguGOwtDWfq7H+x1qvTs8lkF8zZlmZUtUWBdbH53LtGruJf
         vSj+LKh2HYhSVZZb8dZnoeXEm4+SKqynuS5G4=
Message-ID: <f188924b0809220154w78d8ec42p3c8aad766a320ee@mail.gmail.com>
Date: Mon, 22 Sep 2008 10:54:07 +0200
From: "Fred ." <eldmannen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: I/O asynchronous cancellation
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I read on;
* http://widefox.pbwiki.com/Kernel%20New%20Features%20Comparison#Last%20on%20Linux

That Linux does not have I/O asynchronous cancellation support.
How come not?
It seems there are patches for it, so include it in mainline.

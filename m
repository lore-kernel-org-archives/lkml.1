Return-Path: <linux-kernel-owner+w=401wt.eu-S1751596AbXBOGbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbXBOGbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 01:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbXBOGbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 01:31:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:40438 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbXBOGbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 01:31:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OF79lvJBeUan/WThrOv17IoFrPRYZSM0hYIJ3z18/n2O/CuC2GYn8w6qPzo0rj6drBbt+PA8DlR6bKBYtNARsP8S6+QIanCUSG+RfyZI4JBOPNb91XCvNsqgNboo84Yhk+I9Qv5/pKfmhj5bu5TqSBEa5SKickrNDn8oXMImsvs=
Message-ID: <3634de740702142231k938a4c5ic824c2eefc95c1b0@mail.gmail.com>
Date: Thu, 15 Feb 2007 12:01:37 +0530
From: Maximus <john.maximus@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: irqdesc porting help
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Im trying to port some drivers between 2.6.14 and 2.6.19

I find that irqdesc has changed completely. how do i port
the drivers between 2.6.14 and 2.6.19?

is there a porting guide available to port the drivers
which use irqdesc?.

my drivers use variables triggered, ... which dont exist in 2.6.19
irqdesc strcuture.


Could anyone help me on this.

Regards,
Jo

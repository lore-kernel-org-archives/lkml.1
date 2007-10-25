Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbXJYOvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbXJYOvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbXJYOu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:50:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:56633 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbXJYOu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=l5eSyq/dtcve3EPc+LXzhd0Y2utue0ZeTZCvEeWD0o6rrxup9+hDvuxsbODIAWiO3aDPGAGiyQZ6wzv9TqmFXOhwvAE9wtt2AVidWrXo0NOt6YqgoJZ7N4Db98V3MJ+JmwFgx6VldSnJuR7DrnWmGl13be3z6FGOGRxNTfoe2X4=
Message-ID: <2ed59cbb0710250750w73d2b29dwee0f1038fa9dff18@mail.gmail.com>
Date: Thu, 25 Oct 2007 10:50:50 -0400
From: "Zurk Tech" <zurktech@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Quad core CPU detected but shows as single core in 2.6.23.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

duh. never mind. i had an attack of the stupids and enabled GART error
reporting in the bios menu when i installed the motherboard. fixed
now. shows all 4 and 8 on the other one.
-z-

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbZCXXOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbZCXXOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZCXXOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:14:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45143 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbZCXXOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:14:20 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
       "stoyboyker@gmail.com" <stoyboyker@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 24 Mar 2009 18:14:12 -0500
Subject: RE: [PATCH 12/13][Resubmit][drivers/media] changed ioctls to
 unlocked
Thread-Topic: [PATCH 12/13][Resubmit][drivers/media] changed ioctls to
 unlocked
Thread-Index: AcmsyX0UswqWUmK5RL6pt0JK2Hk9bQAC9MegAAA1nFA=
Message-ID: <A24693684029E5489D1D202277BE89442E804BDD@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89442E804BDB@dlee02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  {
> > +	lock_kernel();
> > +
> 
> Why moving to unlocked_ioctl if you're acquiring the Big Kernel Lock
> anyways?

Ok, forget it, just saw Alexey mail chain...

Understood.

Regards,
Sergio

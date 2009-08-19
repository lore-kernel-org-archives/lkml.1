Return-Path: <linux-kernel-owner+w=401wt.eu-S1751222AbZHSBKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbZHSBKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbZHSBKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:10:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43518 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbZHSBKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:10:00 -0400
Subject: Re: clock freezes??
From: john stultz <johnstul@us.ibm.com>
To: Victor =?ISO-8859-1?Q?Matar=E9?= <matare@lih.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200908181743.20381.matare@lih.rwth-aachen.de>
References: <4A69C03E.3090706@lih.rwth-aachen.de>
	 <4A8190C0.5030400@lih.rwth-aachen.de> <1250008935.30440.8.camel@work-vm>
	 <200908181743.20381.matare@lih.rwth-aachen.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Aug 2009 18:08:55 -0700
Message-Id: <1250644135.7002.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 17:43 +0200, Victor Mataré wrote:
> just to be clear:
> > Can you trigger the problem yourself using date -s ?
> nope.

Ok. Then I suspect the hang isn't ntp related, but we'll keep watching
it.

thanks
-john


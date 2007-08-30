Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbXH3N4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbXH3N4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXH3Nzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:55:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:47985 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbXH3Nzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nAb8xfCtDZE4Yi+eP+Ab3dn3X/MFlaB2ZD9oNFaQewjZsKlck3c1qVecA2JHf1Pj/FgLKxWO6FoA96ziSJkbe/guHt3Qfx2XHSw52eQ5t29WhE4z36JF3TFs3rNgpVmeke6TRjSWKghjRqqnt7F6D6JO4sJqoNQ6NcT1tbDeFaw=
Message-ID: <38b2ab8a0708300655n7ae6a445y84150ab1bdcdf2d4@mail.gmail.com>
Date: Thu, 30 Aug 2007 15:55:49 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: i2c transfers during interrupt context
Cc: khali@linux-fr.org
In-Reply-To: <38b2ab8a0708300311x5479effn5999ba118221a47f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0708300311x5479effn5999ba118221a47f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a very simple question about i2c transfers.

I'm wondering if I'm allowed to initiate some very short i2c transfers
in an interrupt handler.

Thanks for your answers.
--
Francis


-- 
Francis

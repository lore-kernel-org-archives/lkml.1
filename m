Return-Path: <linux-kernel-owner+w=401wt.eu-S1752172AbXLESXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbXLESXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 13:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXLESXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 13:23:41 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:41867 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbXLESXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 13:23:40 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH] USB: option: Bind to the correct interface of the Huawei E220
Date: Wed, 5 Dec 2007 19:23:14 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jaime Velasco Juan <jsagarribay@gmail.com>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       Rui Santos <rsantos@grupopie.com>, linux-usb@vger.kernel.org,
       preining@logic.at, kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org, greg@kroah.com
References: <20071128161305.b01167b3.zaitcev@redhat.com> <20071130163011.GA4223@singular.local> <20071205083423.ca6ef199.zaitcev@redhat.com>
In-Reply-To: <20071205083423.ca6ef199.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712051923.15997.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 5. Dezember 2007 17:34:23 schrieb Pete Zaitcev:
> Looks good to me, shorter than my patch, has no duplication, allows to
> use the storage, looks like a winner. Unfortunately, it leaves ub for dead,

Is that new? How could ub do this up to now?

	Regards
		Oliver


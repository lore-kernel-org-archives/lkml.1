Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbXLESbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbXLESbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 13:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXLESbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 13:31:17 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:33859 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbXLESbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 13:31:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oP7nzSeISkQAM5q++KpaTxqsP1BWB/pwRx4ifShf0BkYDZlpG78vBaMoT55FMZg/bZ3umE50X8KnA88OledC0PTj7hkh/gP/p9WVWYPOCYFl+meHiNox+Eta7ElJ8ArtKGtvqkXNwzxoGtiVnVuG07sd6CXo/IsP//4lkl3tiTA=
Message-ID: <a372714f0712051031n31b933bfw6a5f9cb57b8cb5b8@mail.gmail.com>
Date: Wed, 5 Dec 2007 10:31:14 -0800
From: "Brett Warden" <brett.warden@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] bw-qcam: adds parameter aggressive to skip passive detection and directly attempt initialization
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <20071205173756.0cd80e85@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071205173756.0cd80e85@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 5, 2007 9:37 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Although I would suggest that "aggressive" may not be the best term - I'm
> not such of a good one however - skip_passive ?

How about force_init?

-- 
Brett Warden

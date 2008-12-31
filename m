Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbYLaSgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbYLaSgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYLaSgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:36:15 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:3561 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYLaSgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:36:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cIT4fA2aD6y3zZpeEMfcGOHk/9PWC+uJ4/Ixh6Xbbf5eVV0Nmqh79oVDWvfH0kf++B
         wo68pjnS/6pg16lUF0dq0e1HYFZXEmpUrR/yGJeJefPNNAh5PFwufG0eZuhlQm9sIvLQ
         fXXph6YfiAPGYb6k02/mjXaudoDkAiIHPzBGY=
Message-ID: <15ddcffd0812311036m2f006c4fhaa0064eadc7b3924@mail.gmail.com>
Date: Wed, 31 Dec 2008 20:36:12 +0200
From: "Or Gerlitz" <or.gerlitz@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.29
Cc: "Or Gerlitz" <ogerlitz@voltaire.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
In-Reply-To: <adaabacqp2m.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aday6y7x2yr.fsf@cisco.com> <495B66AE.1050706@voltaire.com>
	 <adaabacqp2m.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 6:36 PM, Roland Dreier <rdreier@cisco.com> wrote:
>> What about Jack's raw QP support/fixes patch set which he reposted on December 15th?
> didn't make this window.  How are you using raw QPs?

soon want to play/experience with sniffer prototype, any chance they
would eventually make it for this window?

Or.

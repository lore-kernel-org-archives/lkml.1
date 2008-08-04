Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYHDSSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYHDSSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYHDSSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:18:11 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:42383 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbYHDSN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:13:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cCkN/Mc+34iQQKpwnsXTFJMUMKELENTERsDM9LvTfSyc+18ao/yPJoMZSe9mDCiRxI
         +JsMSkOhZzvRgONJvceH2IT25L1ya5P/7fYfZdwzR1n3thSi0MkhWyZ614W6iny/ji8D
         ie9Ncv7130wHrgxqvbZP8rlZ+7+n1L+HIt3D4=
Message-ID: <36ca99e90808041113o4e1fafd9ucb06f5acbbad13ba@mail.gmail.com>
Date: Mon, 4 Aug 2008 20:13:27 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "TAKADA Yoshihito" <takada@mbf.nifty.com>
Subject: Re: How does RCU work?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080805.000943.208968239.takada@mbf.nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080805.000943.208968239.takada@mbf.nifty.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 17:09, TAKADA Yoshihito <takada@mbf.nifty.com> wrote:
> Hi.
> I cannot understand mechanism. Somebody tell me it please.
There are plenty of resources on the net. Try:

  http://www.rdrop.com/users/paulmck/RCU/
  http://en.wikipedia.org/wiki/RCU

Regards
Bert
